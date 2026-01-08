#!/bin/sh
set -e

mkdir -p /var/lib/tailscale /var/run/tailscale

# Find tailscaled binary
TAILSCALED=$(which tailscaled || find / -name tailscaled -type f 2>/dev/null | head -1)

if [ -z "$TAILSCALED" ]; then
  echo "Error: tailscaled not found"
  exit 1
fi

echo "Found tailscaled at: $TAILSCALED"

# Start tailscaled in background with userspace networking
$TAILSCALED --state=/var/lib/tailscale/tailscaled.state --tun=userspace-networking &
TS_PID="$!"

sleep 1

if [ -n "${TAILSCALE_AUTHKEY}" ]; then
  echo "Authenticating with Tailscale..."
  tailscale up --authkey="${TAILSCALE_AUTHKEY}" --hostname="${TS_HOSTNAME:-docker-tailscale}" ${TAILSCALE_EXTRA_ARGS}
else
  echo "Warning: TAILSCALE_AUTHKEY not set. Container will start tailscaled only. Run 'tailscale up' inside container to authenticate."
fi

echo "Tailscale started. PID: $TS_PID"

# If command arguments provided (e.g. nginx -g 'daemon off;'), exec them so container runs nginx in foreground
if [ "$#" -gt 0 ]; then
  echo "Executing: $@"
  exec "$@"
else
  # No command provided: wait on tailscaled process (fallback)
  wait "$TS_PID"
fi

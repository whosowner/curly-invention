
#!/bin/bash
set -e

if [ -z "$DESKTOP_PASSWORD" ] || [ "${#DESKTOP_PASSWORD}" -lt 8 ]; then
    echo "Set DESKTOP_PASSWORD to at least 8 characters"
    exit 1
fi

# Create VNC password file
printf '%s\n' "$DESKTOP_PASSWORD" | \
    vncpasswd -f > /home/desktop/.vnc/passwd

chown desktop:desktop /home/desktop/.vnc/passwd
chmod 600 /home/desktop/.vnc/passwd

# Configure XFCE startup
cat > /home/desktop/.vnc/xstartup <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec dbus-launch --exit-with-session startxfce4
EOF

chown desktop:desktop /home/desktop/.vnc/xstartup
chmod +x /home/desktop/.vnc/xstartup

# Start VNC desktop
su - desktop -c \
  "tigervncserver :1 -localhost yes -geometry 1280x800 -depth 24 -SecurityTypes VncAuth"

# Start browser-based VNC gateway
PORT=${PORT:-10000}

exec websockify \
  --web=/usr/share/novnc \
  0.0.0.0:$PORT \
  localhost:5901

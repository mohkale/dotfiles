link-to "$XDG_BIN_DIR" cmds/*

makedir "$XDG_CONFIG_HOME/cron-user.d"
info 'Generating mail-to-self cron record'
run-cmds <<-'EOF'
echo "MAILTO=$USER@localhost" > "$XDG_CONFIG_HOME/cron-user.d/mail-to-self.cron"
EOF

# Provides chronic.
packagex chronic

#!/bin/sh
set -x
# install mackerel-agent
mackerel_agent=/app/mackerel-agent/mackerel-agent
mackerel_agent_conf=/app/mackerel-agent/mackerel-agent.conf

cd /app/ && \
  curl -O http://file.mackerel.io/agent/tgz/mackerel-agent-latest.tar.gz && \
  tar xvfz mackerel-agent-latest.tar.gz
sh << SCRIPT
cat > $mackerel_agent_conf <<'EOF';
pidfile = "/app/mackerel-agent/mackerel-agent.pid"
root = "/app/mackerel-agent"
apikey = "${MACKEREL_API_KEY}"
roles = [ "fni-bot:web" ]
[plugin.metrics.process]
command="/app/hubot-process.sh"
type="metric"
EOF
SCRIPT
trap "$mackerel_agent retire -conf $mackerel_agent_conf -force" TERM
$mackerel_agent -conf $mackerel_agent_conf -v &

./bin/hubot -a slack -n fni-bot

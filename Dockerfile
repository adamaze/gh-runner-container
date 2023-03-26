FROM rockylinux:9

ARG RUNNER_VERSION="2.303.0"

RUN dnf update -y && dnf install -y podman

RUN useradd -m runner

RUN dnf install -y jq

RUN mkdir /home/runner/actions-runner && cd /home/runner/actions-runner\
&& curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
&& tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R runner /home/runner && /home/runner/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

USER runner

ENTRYPOINT ["./start.sh"]

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

COPY migrations/ /tmp/migrations/

RUN chmod -R +x /tmp/migrations && \
    /tmp/migrations/migrate.sh

USER developer
WORKDIR /home/developer

RUN /tmp/migrations/migrate.sh

USER root

RUN rm -rf /tmp/migrations

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
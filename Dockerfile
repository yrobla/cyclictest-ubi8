FROM registry.redhat.io/ubi8/ubi
ENV DURATION=1m
ENV RESULT_DIR=/tmp/cyclictest
ENV rt_priority=stress_tool
USER 0

COPY start_cyclictest.sh /root/
RUN chmod 777 /root/start_cyclictest.sh

RUN REPOLIST=rhel-8-for-x86_64-rt-rpms \
    PKGLIST="rt-tests wget tmux" \
    && yum -y install --enablerepo ${REPOLIST} ${PKGLIST} \
    && yum -y clean all \
    && rm -rf /var/cache/yum

RUN wget -O /root/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /root/dumb-init
ENTRYPOINT ["/root/dumb-init",  "--" ]
CMD ["/root/start_cyclictest.sh"]


FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y wget

RUN echo "deb https://deb.torproject.org/torproject.org bookworm main" > /etc/apt/sources.list.d/tor.list

RUN apt-get update && apt-get install -y --allow-unauthenticated tor torsocks 2>&1 || apt-get install -y tor torsocks

RUN mkdir -p /var/lib/tor /var/log/tor && chown -R debian-tor:debian-tor /var/lib/tor /var/log/tor && chmod 700 /var/lib/tor /var/log/tor

COPY torrc /etc/tor/torrc
RUN chown debian-tor:debian-tor /etc/tor/torrc && chmod 600 /etc/tor/torrc

EXPOSE 9001 9030 9051

USER debian-tor

CMD ["/usr/sbin/tor", "-f", "/etc/tor/torrc"]

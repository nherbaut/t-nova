dngroup/adapted-video-frontend:
  docker.pulled:
    - tag: latest



{%- set minealias = salt['pillar.get']('hostsfile:alias', 'network.ip_addrs') %}
{%- set addrs = salt['mine.get']('roles:broker', minealias,"grain") %}
{%- set broker_ip= addrs.items()[0][1][0] %}


{%- set addrs = salt['mine.get']('roles:swift_proxy', minealias,"grain") %}
{%- set swift_proxy_ip= addrs.items()[0][1][0] %}



core-frontend:
  docker.running:
    - image:  dngroup/adapted-video-frontend
    - ports:
      - "8080/tcp":
          HostIp: "0.0.0.0"
          HostPort: "5000"  
    - environment:
      - "AMQP_PORT_5672_TCP_ADDR" : "{{ broker_ip }}"
      - "AMQP_PORT_5672_TCP_PORT" : "5672"
      - "STREAMER_URL" : " http://{{ pillar['ips']['CDN-LB']['Floating_IP'] }}:8080/v1/AUTH_admin/"
    - require: 
      - docker: dngroup/adapted-video-frontend

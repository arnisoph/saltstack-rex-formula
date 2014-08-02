#!jinja|yaml

{% from "rex/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('rex:lookup')) %}

rexrepo:
  pkgrepo:
    - {{ datamap.repo.ensure|default('managed') }}
    - name: {{ datamap.repo.debtype|default('deb') }} {{ datamap.repo.url }} {{ datamap.repo.dist|default(salt['grains.get']('oscodename')) }}{% for c in datamap.repo.comps|default(['rex']) %} {{ c }}{% endfor %}
    - file: /etc/apt/sources.list.d/rex.list
  {% if datamap.repo.keyurl is defined %}
    - key_url: {{ datamap.repo.keyurl }}
  {% endif %}

rex:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}

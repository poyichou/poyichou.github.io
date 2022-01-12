---
layout: default
title: Notes
---
<h1>Notes</h1>

{% for note in site.notes %}
  {% include note_template.md content="{{ note.title }}" %}
{% endfor %}

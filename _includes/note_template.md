{% capture details %}
{% include_relative notes/{{ include.content }}.md %}
{% endcapture %}
{% capture summary %}{{ include.content }}{% endcapture %}{% include details.html %}

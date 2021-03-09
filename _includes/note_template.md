{% capture details %}
{% include_relative notes/{{ include.content }}.md %}
{% endcapture %}
{% capture summary %}{{ include.content }}[->](/notes/{{ include.content }}.md){% endcapture %}{% include details.html %}

[{{ include.content }}](/notes/{{ include.content }}.md)
{% capture details %}
{% include_relative notes/{{ include.content }}.md %}
{% endcapture %}
{% capture summary %}View{% endcapture %}{% include details.html %}

{% capture details %}
{% include_relative notes/{{ include.content }}.md %}
{% endcapture %}
{% capture summary %}<a href="https://poyichou.github.io/notes/{{ include.content }}.html">{{ include.content }}</a><br>&gt;{% endcapture %}{% include details.html %}

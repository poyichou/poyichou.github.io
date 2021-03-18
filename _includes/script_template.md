[{{ include.name }}](scripts/{{ include.name }})  
{% capture details %}
    {% highlight {{ include.code_type }} %}
{% include_relative notes/{{ include.name }} %}
    {% endhighlight %}
{% endcapture %}
{% capture summary %}{{ include.description }}{% endcapture %}{% include details.html %}

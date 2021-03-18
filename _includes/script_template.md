[{{ include.name }}](scripts/{{ include.name }})  
{% capture details %}
    {% highlight {{ include.code_type }} %}
{% include_relative scripts/{{ include.name }} %}
    {% endhighlight %}
{% endcapture %}
{% capture summary %}{{ include.description }}{% endcapture %}{% include details.html %}

---
layout: page
title: Welcome to MetalElf0 weblog
tagline: sed 's/boring\_stuff/ruby/g'
published: true
---
{% include JB/setup %}

<ul class="tag_box inline">
  {% assign categories_list = site.categories %}
  {% include JB/categories_list %}
</ul>

{% assign firstPost = site.posts.first %}
{{ firstPost.content | truncatehtml: 450 }}
<a id="more" href="{{ firstPost.url }}">Read More &raquo;</a>

## Recent posts:

<ul class="posts">
  {% for post in site.posts limit:5 %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

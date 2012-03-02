---
layout: page
title: Welcome to MetalElf0 weblog
tagline: sed 's/boring_stuff/ruby/g'
published: true
---
{% include JB/setup %}

<ul class="tag_box inline">
  {% assign categories_list = site.categories %}
  {% include JB/categories_list %}
</ul>

{% for currentPost in site.posts limit:5 %}
  {% assign currentPost = site.posts.first %}
  <div class="row">
    <div class="span10">
      <div>
        <h2>{{ currentPost.title }} <small>{{ currentPost.tagline }}</small></h2>
      </div>
      {{ currentPost.content }}
      <a id="more" href="{{ currentPost.url }}">See article &raquo;</a>
      <hr/>
    </div>
    
    <div class="span4">
      <h4>Published</h4>
      <div class="date"><span>{{ currentPost.date | date_to_long_string }}</span></div>

    {% unless currentPost.tags == empty %}
      <h4>Tags</h4>
      <ul class="tag_box">
      {% assign tags_list = currentPost.tags %}
      {% include JB/tags_list %}
      </ul>
    {% endunless %}  
    </div>
  </div>
{% endfor %}

<hr/>

## Recent posts:

<ul class="posts">
  {% for post in site.posts limit:5 %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

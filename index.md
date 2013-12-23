---
layout: page
title: Welcome to MetalElf0 weblog
tagline: sed 's/boring_stuff/ruby/g'
published: true
---
{% include JB/setup %}

<div class="row">
  <div class="col-md-10 col-md-offset-2">
    <ul class="nav nav-pills">
      {% assign categories_list = site.categories %}
      {% include JB/categories_list %}
    </ul>
  </div>
</div>

{% for currentPost in site.posts limit:5 %}
  {% assign currentPost = site.posts.first %}
  <div class="row post">
    <div class="col-md-8 col-md-offset-2">
      <div>
        <h2>{{ currentPost.title }} <small>{{ currentPost.tagline }}</small></h2>
      </div>
      {{ currentPost.content | postmorefilter: currentPost.url, "Read the rest of this entry &raquo;" }}
      <hr/>
    </div>

    <div class="col-md-2">
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

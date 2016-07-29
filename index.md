---
layout: page
title: Welcome to MetalElf0 weblog
tagline: sed 's/boring_stuff/ruby/g'
published: true
theme:
  name: bootstrap-3
---
{% include JB/setup %}

<div class="row">
  <div class="well col-md-10 col-md-offset-2">
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
      <div class="page-header">
        <h2>{{ currentPost.title }} {% if currentPost.tagline %}<small>{{currentPost.tagline}}</small>{% endif %}</h2>
      </div>
      {{ currentPost.excerpt }}
      <a id="more" href="{{ currentPost.url }}">See article &raquo;</a>
      <hr/>
    </div>

    <div class="col-md-2">
      <div class='sidebar'>
        <div class='panel panel-default panel-small'>
          <div class='panel-heading'>
            <h4>Published</h4>
          </div>
          <div class='panel-body'>
            <div class="date"><span>{{ currentPost.date | date_to_long_string }}</span></div>
          </div>
        </div>

      {% unless currentPost.tags == empty %}
        <div class='panel panel-default panel-small'>
          <div class='panel-heading'>
            <h4>Tags</h4>
          </div>
          <div class='panel-body'>
            <ul class="tag_box nav nav-pills">
              {% assign tags_list = currentPost.tags %}
              {% include JB/tags_list_as_badges %}
            </ul>
          </div>
        </div>
      {% endunless %}
      </div>
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

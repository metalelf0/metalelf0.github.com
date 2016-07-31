---
layout: page
title: MetalElf0 weblog
tagline: sed 's/boring_stuff/ruby/g'
published: true
theme:
  name: bootstrap-3
---
{% include JB/setup %}

<div class='row text-center margin-bottom'>
  <span class='section-title'>Recent posts</span>
</div>

<div class="row">
  {% for currentPost in site.posts limit:8 %}
      {% assign loopindex = forloop.index | modulo: 4 %}

      <div class="col s12 m3">
        <div class="card">
          <div class="card-content">
            <span class="card-title">{{ currentPost.title }}</span>

            {% if currentPost.tagline %}
              <p>{{currentPost.tagline}}</p>
            {% endif %}
          </div>
          <div class="card-action">
            <a href="{{ currentPost.url }}">Read article</a>
          </div>
        </div>
      </div>


    {% if loopindex == 0 %}
      <div class="clearfix"></div>
    {% endif %}

  {% endfor %}
</div>

<div class="row">
<div class='row text-center margin-bottom'>
  <span class="see-more">
    <a href="/archive.html" alt="Archive">See more...</a>
  </span>
</div>

</div>

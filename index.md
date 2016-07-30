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

      <div class="col-sm-12 col-md-3">
        <div class="panel panel-default">
          <div class="panel-body">
            <div class="box-title">
              <a href="{{ currentPost.url }}">{{ currentPost.title }}</a>
            </div>

            {% if currentPost.tagline %}
              <div class="box-tagline"><span>{{currentPost.tagline}}</span></div>
            {% endif %}
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

---
layout: post
title: "Format the results of a MySQL query like MySQL! In Rails!"
category: rails
tagline: good old ascii tables
tags: [ruby, mysql, rails, table, terminal-table]
theme:
  name: journal
---
{% include JB/setup %}

It may happen that you need to display the results of a MySQL query on a page. E.g., your customer asks you to add a report on a page, and you don't want to build a custom template, but just write the query and see the results.

We can do this easily thanks to the terminal-table gem (see <a href="http://github.com/visionmedia/terminal-table">http://github.com/visionmedia/terminal-table</a>). This gem allows printing an ASCII table, just like the one you see when you use MySQL from the terminal. Look at its page on GitHub to see how easy it is.

To integrate it with MySQL and Rails, we can use `ActiveRecord::Base.connection.execute("some_sql_query")`. This method extracts the result of our query to a `Mysql::Result` object, which consists of a set of hashes with the results of the query. We can navigate through this hashes iterating over the all_hashes method, and throw these results into a table. Here's the code:

<script src="https://gist.github.com/702423.js"> </script>

So all we need to do is include our module and call the method `print_results_of_query`. Look at this example in script/console:

<script src="https://gist.github.com/702418.js"> </script>

Just wrap it into `<%=` and `%>` markers in your .html.erb template. Have fun!

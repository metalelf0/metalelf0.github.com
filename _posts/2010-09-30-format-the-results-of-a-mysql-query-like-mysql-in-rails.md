---
title: Format the results of a MySQL query like MySQL! In Rails!
date: "2010-09-30T00:00:00Z"
categories:
- posts
- technical
tags:
- ruby
- mysql
- rails
- table
- terminal-table
---

It may happen that you need to display the results of a MySQL query on a page. E.g., your customer asks you to add a report on a page, and you don't want to build a custom template, but just write the query and see the results.

We can do this easily thanks to the terminal-table gem (see [http://github.com/visionmedia/terminal-table](http://github.com/visionmedia/terminal-table). This gem allows printing an ASCII table, just like the one you see when you use MySQL from the terminal. Look at its page on GitHub to see how easy it is.

To integrate it with MySQL and Rails, we can use `ActiveRecord::Base.connection.execute("some_sql_query")`. This method extracts the result of our query to a `Mysql::Result` object, which consists of a set of hashes with the results of the query. We can navigate through this hashes iterating over the all_hashes method, and throw these results into a table. Here's the code:

```ruby
module MysqlQueryResultsFormatter
  require 'terminal-table/import'

  def print_results_of_query query
    result = ActiveRecord::Base.connection.execute(query)
    return nil if result.nil?
    results_table = table do |t|
      results = result.all_hashes
      t.headings = results.first.keys
      results.each do |each_row|
        t << each_row.values
      end
    end
    puts results_table
  end
end
```

So all we need to do is include our module and call the method `print_results_of_query`.

Just wrap it into `<%=` and `%>` markers in your .html.erb template. Have fun!

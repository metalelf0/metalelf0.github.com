---
layout: post
title: "Fluentd usage example with bash and ruby"
tagline: "Json logging for everyone"
category: tools
tags: [ruby, logging, json, fluentd, bash, shell]
theme:
  name: journal
---
{% include JB/setup %}

<img class="fluentd-example" src="https://raw.github.com/fluent/website/master/logos/fluentd2.png" alt="fluentd-logo"/>

[Fluentd](http://fluentd.org/) is an open source tool to collect events and
logs. Its architecture allows to easily collect logs from different input
sources and redirect them to different output sinks. Some input examples are
HTTP, syslog, or apache logs, and some output sinks are files, mail, and
databases (both RDBMS and NoSQL ones). Also, it allows to parse logs and to
extract only the significative parts from each of them; saving this
structured information on a DB allows much easier log searching and analysis.

<img class="fluentd-example" src="http://docs.fluentd.org/images/apache-to-mongodb.png" alt="fluentd-example"/>

The fluentd architecture can be extended with ruby plugins to support input
sources and output destinations; for the scope of this example, we will use:

* [MongoDB plugin for Fluent event collector](https://github.com/fluent/fluent-plugin-mongo);
* [fluent-logger rubygem](https://github.com/fluent/fluent-logger-ruby);
* the built-in tcp input and stdout output.

### Installing fluentd server

The first thing to do is installing the fluentd server. You can easily do this
via rubygems (beware it requires at least ruby 1.9.2):

    $ gem install fluentd

When you're done you can create a setup file:

    $ fluentd -s ~/.fluentd

This will create the file `~/.fluentd/fluent.conf` and setup the `~/.fluent/plugins` folder.

### The fluentd.conf file

Edit the configuration file with your favourite editor (which is vim, of
course), and make it look like this:

{% gist 6193677 %}

You can see it's made of three parts:

1. The first one is the default HTTP source input. It listens for JSON messages
on port `24224`.
2. The second one is the default standard output. The `match fluentd.test.**`
line tells fluentd to forward all messages matching the given pattern to the
chosen standard output.
3. The third block is the MongoDB output. It requires the MongoDB plugin cited
above to be installed, but we'll talk about this later.

Let's start the server and keep it running in foreground, to easily see
incoming messages:

    $ fluentd -c ~/.fluent/fluent.conf

### Logging from bash to STDOUT

Now, let's prepare a sample bash script to log things to `fluentd`. Open
another terminal, create a bash script and paste the following content:

{% gist 6194294 %}

As you can see I created a wrapper function to make it easier to redirect logs
to `fluentd`. Save the file, make it executable and run it. You should see output
like this in your server:

    2013-08-09 17:01:06 +0200 [trace]: plugin/in_forward.rb:150:initialize: accepted fluent socket object_id=70144024060720
    2013-08-09 17:01:06 +0200 fluentd.test.log: {"project":"Library","script_name":"Reload books","message":"Started"}
    2013-08-09 17:01:06 +0200 [trace]: plugin/in_forward.rb:191:on_close: closed fluent socket object_id=70144024060720

This is telling us that `fluentd` is accepting input from the `fluent-cat` command
and it is redirecting it to standard output, according to the first rule.

### Logging from bash to MongoDB

To go on in our test, we need to install MongoDB. Use the best way depending on
your system (I used `homebrew` on my mac), run it and connect to its console via
the `mongo` command.

Now, in the previous bash script, change the target of `fluent-cat` from
`fluentd.test.log` to `mongo.log`. Save it, run it again, and type this in your
MongoDB console:

    $ db.test.find()

This time you should see an entry in the `test` collection:

    { "_id" : ObjectId("5204dfee9f60b167da000004"), "project" : "Library", "script_name" : "Reload books", "message" : "Started", "time" : ISODate("2013-08-09T12:26:22Z") }

### Logging from bash to MongoDB

Let's see how to achieve the same result in a ruby script. Install the fluent-logger
rubygem with 

    $ gem install fluent-logger

Then create a ruby script with the following content:

{% gist 6194505 %}

Run it, rerun the query in the MongoDB console, and a new entry should be present.


    { "_id" : ObjectId("5204dfee9f60b167da000005"), "project" : "Library", "script_name" : "Reload books", "message" : "Completed", "time" : ISODate("2013-08-09T12:46:32Z") }

### Final considerations

The ease of use of `fluentd` allows to quickly setup a centralized log system in
just a few hours. You could use any tool you want to browse data in the MongoDB
database. You can make elaborate statistics, build charts, and do everything you
want with it. According to the `fluentd` website, its simple architecture allows
it to run with very good performances:

    "Fluentd’s performance has been proven in the field: its largest user
    currently collects logs from 5000+ servers, 5 TB of daily data, handling
    50,000 msgs/sec at peak time."

So, I hope this post helped you to understand what this tool is about. I
suggest you to check out the [fluentd
documentation](http://docs.fluentd.org/articles/quickstart) to know more, it's
really complete and clear. If you found this post useful, feel free to drop me
a line :)



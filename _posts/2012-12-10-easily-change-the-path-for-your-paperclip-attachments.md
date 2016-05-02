---
layout: post
title: "Easily change the path for your Paperclip attachments"
tagline: "And prevent filename clashes"
category: rails
tags: [rails, ruby, paperclip]
theme:
  name: journal
---
{% include JB/setup %}

Today after releasing an app to production environment I saw a couple of
[paperclip](https://github.com/thoughtbot/paperclip) warnings like this 
in my production.log file:

    [paperclip] Duplicate URL for round_image with /system/:attachment/:id/:style/:filename. This will clash with attachment defined in PageElements::FranchisingCarouselEntry class

This happens because I defined an attachment with the same name in two
different models, and the default strategy Paperclip uses to choose
attachment locations could lead to filename clashing.

Here is a more detailed example:

    class Foo
      has_attached_file :image
    end

    class Bar
      has_attached_file :image
    end

The default strategy Paperclip uses to store attachments relies on this
path: `/system/:attachment/:id/:style/:filename`.

So, considering our example, if we uploaded two files called `image.png`
for the first `Foo` instance and the first `Bar` instance, they would
have the same path, `/system/image/1/original/image.png`.

The solution is quite easy; if we add the following line to our
`config/environment.rb` file, Paperclip will add an extra directory
level to separate files across different models:

    Paperclip::Attachment.default_options[:url] = "/system/:class/:attachment/:id/:style/:filename"

From now on Paperclip will search for files in the
`system/foo/image/1/original/image.png` and
`system/bar/image/1/original/image.png` locations. But we still need to
move our previously uploaded files to the new path. We can do this with
this rake task:


    desc "Copy paperclip data"
    task :copy_paperclip_data => :environment do

      def move_images klass, attachment_name
        print "Moving #{attachment_name.pluralize} for #{klass}: "
        instances = klass.find :all
        instances.each do |instance|
          file_name_method = attachment_name + "_file_name"
          unless instance.send(file_name_method).blank?
            filename = Rails.root.join('public', 'system', attachment_name.pluralize, instance.id.to_s, 'original', instance.send(file_name_method))
            if File.exists? filename
              old_attachment_file = File.new filename
              instance.send(attachment_name + "=", old_attachment_file)
              instance.save
              old_attachment_file.close
              print "."
            end
          end
        end
        print " [DONE]"
        puts
      end

      move_images Foo, 'image'
      move_images Bar, 'image'

    end

This script is a slightly modified version of the one by Fernando
Marcelo you can see [here](http://fernandomarcelo.com/2012/05/paperclip-how-to-move-existing-attachments-to-a-new-path/).
I changed it a little to make it more verbose and reusable, but big
credits go to him for his original work.

Running this rake task with `rake copy_paperclip_data` will copy all the
original files from their old location to the new one.

You will still see the warning messages in your `production.log` file,
because so far Paperclip is not smart enough to check your custom path
and understand it is enough to prevent conflicts. This will probably be
fixed in future releases of Paperclip gem.


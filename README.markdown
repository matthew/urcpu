About
=====

Install
=======

Get the gem:

    # Add GitHub as a Gem Source (only have to do this once)
    gem sources -a http://gems.github.com
    
    # Install the gem
    sudo gem install matthew-urcpu
    
    # Otherwise, build the gem and install it
    rake gem
    sudo gem install pkg/*.gem

Open up `~/.irbrc` and add these lines:

    require 'rubygems'
    require 'urcpu'
    
Usage
=====

License
=======

Copyright 2008, Matthew O'Connor All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Ruby 1.8.7 itself.

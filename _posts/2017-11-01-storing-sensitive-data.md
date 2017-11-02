---
layout: page
title: "Storing sensitive data"
category: rails
date: 2017-11-01 17:29:52
---

How should your app secure sensitive  data that is kept per-user, such
as a password or API key for each user or other similar record in your
databases? 

We recommend using the `attr_encrypted` gem. 
First read this [great
post](http://www.kendrickcoleman.com/index.php/Tech-Blog/encrypting-data-using-attr-encrypted-with-rails.html)
on
how to do this; if you're using Figaro as recommended in
[this recipe]({{ site.baseurl }}{% post_url 2017-11-01-managing-api-keys %}),
you can store the symmetric-encryption
key(s) used by `attr_encrypted` in your `application.yml` file.
So instead of 

```ruby
attr_encrypted :user, :key => ENV["USERKEY"]
```

as recommended in the above article, you would instead say

```ruby
attr_encrypted :user, :key => Figaro.env.USERKEY
```

# Beware of attr_encrypted and serialize

Be aware that if you are using serialize to store (say) a hash or array
in an ActiveRecord text field, there appear to be some weird
interactions if you try to use attr_encrypted on that field. What I have
found to work is this: 

## Before:

```ruby
class User < ActiveRecord::Base
  serialize :api_keys, Hash
end

User.new.api_keys  # =>  {}
```

## After:

```ruby
class User < ActiveRecord::Base
  attr_encrypted :api_keys, :key => Figaro.env.SECRET, \
     :marshal => true
end

User.new.api_keys  # => nil
```

That last option instructs `attr_encrypted` to marshal the resulting data
structure before encrypting, and unmarshal after reading from the
database and decrypting. However, whereas using `serialize` gives
newly-created attributes a default value of a new instance of the
serialized type (in this case, that would be the empty hash), this is
not true with `attr_encrypted`. To remedy this, if your app relies on the
serialized value always being non-nil, I'd advise using an
`after_initialize` block to enforce the invariant that the attribute's
default value is always an instance of the serialized class: 

```ruby
class User < ActiveRecord::Base
  attr_encrypted :api_keys, :key => Figaro.env.SECRET, \
    :marshal => true
  def ensure_is_hash ; self.api_keys ||= {} ; end
  after_initialize :ensure_is_hash
  private          :ensure_is_hash
  # ...
end

User.new.api_keys  # =>  {}
```

Et voila, with the exception of the `after_initialize` callback, your
encrypted-at-rest attributes will now behave the same way as regular
unencrypted attributes. 


# Readlists::Anonymous

[Readlists](http://readlists.com/) API for anonymous lists.

## Usage

### Ruby

```
readlists = Readlists::Anonymous.create
readlists.title = title
readlists.description = description

urls.each do |url|
  begin
    readlists << url
  rescue Readlists::Anonymous::RequestError => e
  end
end

puts "* Created anynymous readlists"
puts "share-url: #{readlists.share_url}"
puts "public-edit-url: #{readlists.public_edit_url}"
```

### command-line

```shell
$ readlists-anonymous [-t title] [-d description] http://example.com/?url1 http://example.com/?url2 [more url...]
```

## Installation

Or install it yourself as:

    $ gem install readlists-anonymous


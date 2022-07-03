
Use the following for highscores
```
gem "replitdb", "~> 0.1.0"
```

```
require 'sinatra'
require 'replit'

set :protection, :except => :frame_options
set :bind, '0.0.0.0'
set :port, 8080

@db = Replit::Database::Client.new
@db.set('visitors', 0)

get '/' do
  @db = Replit::Database::Client.new
  visitors = @db.get('visitors')
  visitors += 1
  @db.set('visitors', visitors)
  "Hello visitor #{visitors}!"
end
```
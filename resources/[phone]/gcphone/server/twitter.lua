function TwitterGetTweets(a,b)if a==nil then MySQL.Async.fetchAll([===[
	SELECT twitter_tweets.*,
	twitter_accounts.username as author,
	twitter_accounts.avatar_url as authorIcon
	FROM twitter_tweets
	LEFT JOIN twitter_accounts
	ON twitter_tweets.authorId = twitter_accounts.id
	ORDER BY time DESC LIMIT 130
]===],{},b)else MySQL.Async.fetchAll([===[
	SELECT twitter_tweets.*,
	twitter_accounts.username as author,
	twitter_accounts.avatar_url as authorIcon,
	twitter_likes.id AS isLikes
	FROM twitter_tweets
	LEFT JOIN twitter_accounts
	ON twitter_tweets.authorId = twitter_accounts.id
	LEFT JOIN twitter_likes 
	ON twitter_tweets.id = twitter_likes.tweetId AND twitter_likes.authorId = @accountId
	ORDER BY time DESC LIMIT 130
]===],{['@accountId']=a},b)end end;function TwitterGetFavotireTweets(a,b)if a==nil then MySQL.Async.fetchAll([===[
	SELECT twitter_tweets.*,
	twitter_accounts.username as author,
	twitter_accounts.avatar_url as authorIcon
	FROM twitter_tweets
	LEFT JOIN twitter_accounts
	ON twitter_tweets.authorId = twitter_accounts.id
	WHERE twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
	ORDER BY likes DESC, TIME DESC LIMIT 30
]===],{},b)else MySQL.Async.fetchAll([===[
	SELECT twitter_tweets.*,
	twitter_accounts.username as author,
	twitter_accounts.avatar_url as authorIcon,
	twitter_likes.id AS isLikes
	FROM twitter_tweets
	LEFT JOIN twitter_accounts
	ON twitter_tweets.authorId = twitter_accounts.id
	LEFT JOIN twitter_likes 
	ON twitter_tweets.id = twitter_likes.tweetId AND twitter_likes.authorId = @accountId
	WHERE twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
	ORDER BY likes DESC, TIME DESC LIMIT 30
]===],{['@accountId']=a},b)end end;function getUser(c,d,b)MySQL.Async.fetchAll("SELECT id, username as author, avatar_url as authorIcon FROM twitter_accounts WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password",{['@username']=c,['@password']=d},function(e)b(e[1])end)end;function TwitterPostTweet(c,d,f,g,h,b)getUser(c,d,function(i)if i==nil then return end;MySQL.Async.insert("INSERT INTO twitter_tweets (`authorId`, `message`, `realUser`) VALUES(@authorId, @message, @realUser);",{['@authorId']=i.id,['@message']=f,['@realUser']=h},function(j)MySQL.Async.fetchAll('SELECT * from twitter_tweets WHERE id = @id',{['@id']=j},function(k)tweet=k[1]tweet['author']=i.author;tweet['authorIcon']=i.authorIcon;TriggerClientEvent('gcPhone:twitter_newTweets',-1,tweet)TriggerEvent('gcPhone:twitter_newTweets',tweet)end)end)end)end;function TwitterToogleLike(c,d,l,g)getUser(c,d,function(i)if i==nil then return end;MySQL.Async.fetchAll('SELECT * FROM twitter_tweets WHERE id = @id',{['@id']=l},function(k)if k[1]==nil then return end;local tweet=k[1]MySQL.Async.fetchAll('SELECT * FROM twitter_likes WHERE authorId = @authorId AND tweetId = @tweetId',{['authorId']=i.id,['tweetId']=l},function(m)if m[1]==nil then MySQL.Async.insert('INSERT INTO twitter_likes (`authorId`, `tweetId`) VALUES(@authorId, @tweetId)',{['authorId']=i.id,['tweetId']=l},function(n)MySQL.Async.execute('UPDATE `twitter_tweets` SET `likes`= likes + 1 WHERE id = @id',{['@id']=tweet.id},function()TriggerClientEvent('gcPhone:twitter_updateTweetLikes',-1,tweet.id,tweet.likes+1)TriggerClientEvent('gcPhone:twitter_setTweetLikes',g,tweet.id,true)TriggerEvent('gcPhone:twitter_updateTweetLikes',tweet.id,tweet.likes+1)end)end)else MySQL.Async.execute('DELETE FROM twitter_likes WHERE id = @id',{['@id']=m[1].id},function(n)MySQL.Async.execute('UPDATE `twitter_tweets` SET `likes`= likes - 1 WHERE id = @id',{['@id']=tweet.id},function()TriggerClientEvent('gcPhone:twitter_updateTweetLikes',-1,tweet.id,tweet.likes-1)TriggerClientEvent('gcPhone:twitter_setTweetLikes',g,tweet.id,false)TriggerEvent('gcPhone:twitter_updateTweetLikes',tweet.id,tweet.likes-1)end)end)end end)end)end)end;function TwitterCreateAccount(c,d,o,b)MySQL.Async.insert('INSERT IGNORE INTO twitter_accounts (`username`,`password`,`avatar_url`) VALUES(@username,@password,@avatarUrl)',{['username']=c,['password']=d,['avatarUrl']=o},b)end;RegisterServerEvent('gcPhone:twitter_login')AddEventHandler('gcPhone:twitter_login',function(c,d)local g=tonumber(source)getUser(c,d,function(i)if i~=nil then TriggerClientEvent('gcPhone:twitter_setAccount',g,c,d,i.authorIcon)end end)end)RegisterServerEvent('gcPhone:twitter_changePassword')AddEventHandler('gcPhone:twitter_changePassword',function(c,d,p)local g=tonumber(source)getUser(c,d,function(i)if i~=nil then MySQL.Async.execute("UPDATE `twitter_accounts` SET `password`= @newPassword WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password",{['@username']=c,['@password']=d,['@newPassword']=p},function(q)if q==1 then TriggerClientEvent('gcPhone:twitter_setAccount',g,c,p,i.authorIcon)end end)end end)end)RegisterServerEvent('gcPhone:twitter_createAccount')AddEventHandler('gcPhone:twitter_createAccount',function(c,d,o)local g=tonumber(source)TwitterCreateAccount(c,d,o,function(j)if j~=0 then TriggerClientEvent('gcPhone:twitter_setAccount',g,c,d,o)end end)end)RegisterServerEvent('gcPhone:twitter_getTweets')AddEventHandler('gcPhone:twitter_getTweets',function(c,d)local g=tonumber(source)if c~=nil and c~=""and d~=nil and d~=""then getUser(c,d,function(i)local a=i and i.id;TwitterGetTweets(a,function(k)TriggerClientEvent('gcPhone:twitter_getTweets',g,k)end)end)else TwitterGetTweets(nil,function(k)TriggerClientEvent('gcPhone:twitter_getTweets',g,k)end)end end)RegisterServerEvent('gcPhone:twitter_getFavoriteTweets')AddEventHandler('gcPhone:twitter_getFavoriteTweets',function(c,d)local g=tonumber(source)if c~=nil and c~=""and d~=nil and d~=""then getUser(c,d,function(i)local a=i and i.id;TwitterGetFavotireTweets(a,function(k)TriggerClientEvent('gcPhone:twitter_getFavoriteTweets',g,k)end)end)else TwitterGetFavotireTweets(nil,function(k)TriggerClientEvent('gcPhone:twitter_getFavoriteTweets',g,k)end)end end)RegisterServerEvent('gcPhone:twitter_postTweets')AddEventHandler('gcPhone:twitter_postTweets',function(c,d,f)local g=tonumber(source)local r=getPlayerID(source)TwitterPostTweet(c,d,f,g,r)end)RegisterServerEvent('gcPhone:twitter_toogleLikeTweet')AddEventHandler('gcPhone:twitter_toogleLikeTweet',function(c,d,l)local g=tonumber(source)TwitterToogleLike(c,d,l,g)end)RegisterServerEvent('gcPhone:twitter_setAvatarUrl')AddEventHandler('gcPhone:twitter_setAvatarUrl',function(c,d,o)local g=tonumber(source)MySQL.Async.execute("UPDATE `twitter_accounts` SET `avatar_url`= @avatarUrl WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password",{['@username']=c,['@password']=d,['@avatarUrl']=o},function(q)if q==1 then TriggerClientEvent('gcPhone:twitter_setAccount',g,c,d,o)end end)end)AddEventHandler('gcPhone:twitter_newTweets',function(tweet)local s="https://discordapp.com/api/webhooks/746725444803362837/CtxjXkn_lpbiTXesNoE9onI7KsoA8Ag1z2wavYv-mgpMK2WDdmErmcX1PeazNnrMRl62"if s==''then return end;local t={['Content-Type']='application/json'}local e={["username"]=tweet.author,["embeds"]={{["thumbnail"]={["url"]=tweet.authorIcon},["color"]=1942002,["timestamp"]=os.date("!%Y-%m-%dT%H:%M:%SZ",tweet.time/1000)}}}local u=string.sub(tweet.message,0,7)=='http://'or string.sub(tweet.message,0,8)=='https://'local v=string.sub(tweet.message,-4)local w=v=='.png'or v=='.pjg'or v=='.gif'or string.sub(tweet.message,-5)=='.jpeg'if u and w and true then e['embeds'][1]['image']={['url']=tweet.message}else e['embeds'][1]['description']=tweet.message end;PerformHttpRequest(s,function(x,y,t)end,'POST',json.encode(e),t)end)
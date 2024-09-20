# Javascript Shell

* database，一个 database 中有多个 collection。
* collections，类似 MySQL 中的 table。
* 同一个 database 中的所有 collections，会写入硬盘上的同一个文件。


## 插入操作

```
> use tutorial
switched to db tutorial

> db.users.insert({username: "waterdragon"})
WriteResult({ "nInserted" : 1 })

> db.users.insert({username: "phay"})
WriteResult({ "nInserted" : 1 })

> db.users.insert({username: "phay"})
WriteResult({ "nInserted" : 1 })

> db.users.find()
{ "_id" : ObjectId("5a7bfb5ac53b13638b843c78"), "username" : "waterdragon" }
{ "_id" : ObjectId("5acc094ba684f7be16ef419f"), "username" : "phay" }
{ "_id" : ObjectId("5acc0ac24357891885ffedf6"), "username" : "phay" }

> db.users.count()
3
```


## 查询操作

```
> db.users.find({username: "phay"})
{ "_id" : ObjectId("5acc094ba684f7be16ef419f"), "username" : "phay" }
{ "_id" : ObjectId("5acc0ac24357891885ffedf6"), "username" : "phay" }

> db.users.find({_id: ObjectId("5a7bfb5ac53b13638b843c78")})
{ "_id" : ObjectId("5a7bfb5ac53b13638b843c78"), "username" : "waterdragon" }
```

$and 查询

```
> db.users.find({
... _id: ObjectId("5a7bfb5ac53b13638b843c78"),
... username: "waterdragon",
... })
{ "_id" : ObjectId("5a7bfb5ac53b13638b843c78"), "username" : "waterdragon" }
```

等价于

```
> db.users.find({ $and: [
... { _id: ObjectId("5a7bfb5ac53b13638b843c78") },
... { username: "waterdragon" }
... ] })
{ "_id" : ObjectId("5a7bfb5ac53b13638b843c78"), "username" : "waterdragon" }
```

也有 $or

```
> db.users.find({ $or: [
... { username: "waterdragon" },
... { username: "phay" }
... ] })
{ "_id" : ObjectId("5a7bfb5ac53b13638b843c78"), "username" : "waterdragon" }
{ "_id" : ObjectId("5acc094ba684f7be16ef419f"), "username" : "phay" }
{ "_id" : ObjectId("5acc0ac24357891885ffedf6"), "username" : "phay" }
```

## 更新操作

加字段 $set

```
> db.users.update({username: "waterdragon"}, {$set: {city: "hangzhou"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })

> db.users.find({username: "waterdragon"})
{ "_id" : ObjectId("5a7bfb5ac53b13638b843c78"), "username" : "waterdragon", "city" : "hangzhou" }
```

替换(replacement update)

```
> db.users.update({username:"phay"}, {username:"phay-usa", city:"???"})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
```

这里发现个问题，只修改了一个 "phay" 对象

```
> db.users.find()
{ "_id" : ObjectId("5a7bfb5ac53b13638b843c78"), "username" : "waterdragon", "city" : "hangzhou" }
{ "_id" : ObjectId("5acc094ba684f7be16ef419f"), "username" : "phay-usa", "city" : "???" }
{ "_id" : ObjectId("5acc0ac24357891885ffedf6"), "username" : "phay" }
```

减字段 $unset

```
> db.users.update({username:"phay-usa"}, {$unset: {city:1}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })

> db.users.find()
{ "_id" : ObjectId("5a7bfb5ac53b13638b843c78"), "username" : "waterdragon", "city" : "hangzhou" }
{ "_id" : ObjectId("5acc094ba684f7be16ef419f"), "username" : "phay-usa" }
{ "_id" : ObjectId("5acc0ac24357891885ffedf6"), "username" : "phay" }

> db.users.update({username:"phay-usa"}, {username: "phay"})
> db.users.find()
{ "_id" : ObjectId("5a7bfb5ac53b13638b843c78"), "username" : "waterdragon", "city" : "hangzhou" }
{ "_id" : ObjectId("5acc094ba684f7be16ef419f"), "username" : "phay" }
{ "_id" : ObjectId("5acc0ac24357891885ffedf6"), "username" : "phay" }
```

* 第三个参数，如果对象不存在，是否直接创建一个新对象
* 第四个参数，是否处理 multi 个对象

```
> db.users.update({username: "phay"}, {$set: {like: "playboy"}}, false, true)
WriteResult({ "nMatched" : 2, "nUpserted" : 0, "nModified" : 2 })

> db.users.find()
{ "_id" : ObjectId("5a7bfb5ac53b13638b843c78"), "username" : "waterdragon", "city" : "hangzhou" }
{ "_id" : ObjectId("5acc094ba684f7be16ef419f"), "username" : "phay", "like" : "playboy" }
{ "_id" : ObjectId("5acc0ac24357891885ffedf6"), "username" : "phay", "like" : "playboy" }
```


## 删除操作

```
> db.users.remove({username: "waterdragon"})
> db.users.find()
{ "_id" : ObjectId("5acc094ba684f7be16ef419f"), "username" : "phay", "like" : "playboy" }
{ "_id" : ObjectId("5acc0ac24357891885ffedf6"), "username" : "phay", "like" : "playboy" }
```

删掉所有对象和索引

```
> db.users.drop()
true
```

## 索引和explain()

```
> for (i=0; i<20000; i++) {
... db.numbers.save({num: i})
... }
WriteResult({ "nInserted" : 1 })

> db.numbers.count()
20000

> db.numbers.find({num: 500})
{ "_id" : ObjectId("5acea89f54d690fac5052ed8"), "num" : 500 }

> db.numbers.find({num: {"$gt": 19995}})
{ "_id" : ObjectId("5acea8a754d690fac5057b00"), "num" : 19996 }
{ "_id" : ObjectId("5acea8a754d690fac5057b01"), "num" : 19997 }
{ "_id" : ObjectId("5acea8a754d690fac5057b02"), "num" : 19998 }
{ "_id" : ObjectId("5acea8a754d690fac5057b03"), "num" : 19999 }

> db.numbers.find({num: {"$gt": 20, "$lt": 25}})
{ "_id" : ObjectId("5acea89e54d690fac5052cf9"), "num" : 21 }
{ "_id" : ObjectId("5acea89e54d690fac5052cfa"), "num" : 22 }
{ "_id" : ObjectId("5acea89e54d690fac5052cfb"), "num" : 23 }
{ "_id" : ObjectId("5acea89e54d690fac5052cfc"), "num" : 24 }

> db.numbers.find({num: {"$gt": 19995}}).explain("executionStats")
...
    "nReturned" : 4,
    "executionTimeMillis" : 10,
    "totalKeysExamined" : 0,
    "totalDocsExamined" : 20000,
...
```

返回了 4 条记录(nReturned)，搜索了 20000 条记录(totalDocsExamined)。一个索引都没用上(totalKeysExamined)。

给 num 这个属性，创建索引

```
> db.numbers.createIndex({num: 1})
{
  "createdCollectionAutomatically" : false,
  "numIndexesBefore" : 1,
  "numIndexesAfter" : 2,
  "ok" : 1
}

> db.numbers.getIndexes()
[
  {
    "v" : 1,
    "key" : {
      "_id" : 1
    },
    "name" : "_id_",
    "ns" : "tutorial.numbers"
  },
  {
    "v" : 1,
    "key" : {
      "num" : 1
    },
    "name" : "num_1",
    "ns" : "tutorial.numbers"
  }
]
```

用上索引之后，各种快。

```
> db.numbers.find({num: {"$gt": 19995}}).explain("executionStats")
...
    "indexName" : "num_1",
...
    "nReturned" : 4,
    "executionTimeMillis" : 0,
    "totalKeysExamined" : 4,
    "totalDocsExamined" : 4,
...
```

## Basic Admin

```
> show databases
local    0.000GB
tutorial  0.001GB

> use tutorial
> show collections
numbers

> db.stats()
{
  "db" : "tutorial",
  "collections" : 1,
  "objects" : 20000,
  "avgObjSize" : 35,
  "dataSize" : 700000,
  "storageSize" : 352256,
  "numExtents" : 0,
  "indexes" : 2,
  "indexSize" : 389120,
  "ok" : 1
}

> db.numbers.stats()
...
```

看函数的代码实现

```
> db.numbers.save
function (obj, opts) {
  if (obj == null)
    throw "can't save a null";

  if (typeof(obj) == "number" || typeof(obj) == "string")
    throw "can't save a number or string"

  if (typeof(obj._id) == "undefined") {
    obj._id = new ObjectId();
    return this.insert(obj, opts);
  }
  else {
    return this.update({_id: obj._id}, obj, Object.merge({upsert:true}, opts));
  }
}
```

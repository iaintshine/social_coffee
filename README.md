Social graph Thrift's service

# Installation

    npm install
    
# Run tests

    npm test

## Requirements

* Globally installed Coffeescript compiler

    [sudo] npm install -g coffeescript

* Globally installed Cake

    [sudo] npm install -g cake

*  Query friends

    SELECT * FROM friendlist WHERE owner = uid

* Create friendship

    INSERT INTO friendship(UID1, UID2) VALUES (1, 2)

* Remove friendship

    DELETE FROM friendship WHERE UID1 == 1 AND UID2 == 2
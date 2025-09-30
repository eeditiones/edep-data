xquery version "3.1";

import module namespace xmldb="http://exist-db.org/xquery/xmldb";

(: The following external variables are set by the repo:deploy function :)

(: file path pointing to the exist installation directory :)
declare variable $home external;
(: path to the directory containing the unpacked .xar package :)
declare variable $dir external;
(: the target collection into which the app is deployed :)
declare variable $target external;

declare function local:mkcol-recursive($collection, $components) {
    if (exists($components)) then
        let $newColl := concat($collection, "/", $components[1])
        return (
            xmldb:create-collection($collection, $components[1]),
            local:mkcol-recursive($newColl, subsequence($components, 2))
        )
    else
        ()
};

(: Helper function to recursively create a collection hierarchy. :)
declare function local:mkcol($collection, $path) {
    local:mkcol-recursive($collection, tokenize($path, "/"))
};

local:mkcol(repo:get-root(), 'edep-data'),
sm:chgrp(xs:anyURI($target), "tei"),
sm:chown(xs:anyURI($target), "edep"),
xmldb:store-files-from-pattern($target, $dir, 'index.xql'),
local:mkcol($target, 'workspace'),
sm:chgrp(xs:anyURI($target || "/workspace"), "tei"),
sm:chown(xs:anyURI($target || "/workspace"), "edep"),
(: store the collection configuration :)
local:mkcol("/db/system/config", $target),
xmldb:store-files-from-pattern(concat("/system/config", $target), $dir, "*.xconf")
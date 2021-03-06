// Q8. Related Topics
/*
  :param { tag: 'Sammy_Sosa' }
*/
MATCH
  (tag:Tag {name: $tag})<-[:hasTag]-(:Message)<-[:replyOf*]-
  (comment:Comment)-[:hasTag]->(relatedTag:Tag)
  // there is no need to filter for relatedTag.name != $tag, as the edge uniqueness constraint takes care of that
WHERE NOT (comment)-[:hasTag]->(tag)
RETURN
  relatedTag.name,
  count(DISTINCT comment) AS count
ORDER BY
  count,
  relatedTag.name
LIMIT 100

// Q10. Central Person for a Tag
/*
  :param {
    tag: 'John_Rhys-Davies',
    date: 20120122000000000
  }
*/
MATCH (tag:Tag {name: $tag})
// score
OPTIONAL MATCH (tag)<-[interest:HAS_INTEREST]-(person:Person)
WITH tag, collect(person) AS interestedPersons
OPTIONAL MATCH (tag)<-[:HAS_TAG]-(message:Message)-[:HAS_CREATOR]->(person:Person)
         WHERE message.creationDate > $date
WITH tag, interestedPersons + collect(person) AS persons
UNWIND persons AS person
// poor man's disjunct union (should be changed to UNION + post-union processing in the future)
WITH DISTINCT tag, person
WITH
  tag,
  person,
  100 * length([(tag)<-[interest:HAS_INTEREST]-(person) | interest])
    + length([(tag)<-[:HAS_TAG]-(message:Message)-[:HAS_CREATOR]->(person) WHERE message.creationDate > $date | message])
  AS score
MATCH (person)-[:KNOWS]-(friend)
WITH
  person,
  score,
  100 * length([(tag)<-[interest:HAS_INTEREST]-(friend) | interest])
    + length([(tag)<-[:HAS_TAG]-(message:Message)-[:HAS_CREATOR]->(friend) WHERE message.creationDate > $date | message])
  AS friendScore
RETURN
  person.id,
  score,
  sum(friendScore) AS friendsScore
ORDER BY
  score + friendsScore DESC,
  person.id ASC
LIMIT 100

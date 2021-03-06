-- Q4. Popular topics in a country
-- tagClass: MusicalArtist
-- country: Burma
select
  f_forumid,
  f_title,
  f_creationdate,
  f_moderatorid,
  count(*) as cnt
from forum, person, country,
  (
    select distinct post.*
    from post, post_tag, tag_tagclass, tagclass
    where tc_name = '$tagClass'
      and ttc_tagclassid = tc_tagclassid
      and ttc_tagid = pst_tagid
      and pst_postid = ps_postid
  ) post
where ps_forumid = f_forumid
  and f_moderatorid = p_personid
  and p_placeid = ctry_city
  and ctry_name = '$country'
group by f_forumid, f_title, f_creationdate, f_moderatorid
order by
  cnt desc,
  f_forumid asc
limit 100;

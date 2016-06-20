drop table t1;

create temp table t1 as
with a as 
(
select cast(stratum_1 as int) as cid, 1000.0*sum(count_value)/(select count_value from nih.achilles_results where analysis_id = 109 and stratum_1='2014')  
as count_value
from nih.achilles_results where analysis_id = 704 and  stratum_2='2014' group by stratum_1,stratum_2 order by 2 desc
) 
select a.cid, a.count_value, cr.concept_id_2 as dose_form_cid, ca.ancestor_concept_id as ingredient_cid from a
left outer join concept_relationship cr on a.cid= cr.concept_id_1
left outer join concept_ancestor ca on a.cid=ca.descendant_concept_id
where 1=1 
--conditions for dose forms
and relationship_id = 'RxNorm has dose form'
and cr.invalid_reason is null
--conditions for ingredients
and ca.ancestor_concept_id in (select concept_id from concept where vocabulary_id = 'RxNorm' and concept_class_id = 'Ingredient' and invalid_reason is null)
;




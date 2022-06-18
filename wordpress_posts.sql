#Select post data, post meta info, featured image, associated attachments and categories. 
#To retrieve another taxonomy copy the corresponding subselect and update the taxonomy (tt.taxonomy = 'category')

#Seleciona dados do post, informações de post meta, imagem destacada, anexos associados ao post e categorias
#para retornar outra taxonomia copie o subselect correspondente e atualize a taxonomia (tt.taxonomy = 'category')

select p.*,
GROUP_CONCAT(CONCAT_WS(':',pm1.meta_key, pm1.meta_value) SEPARATOR '|')as metadata,
(
	SELECT guid from `wp_posts` thumb 
	inner join `wp_postmeta` thumb_meta 
	on thumb_meta.meta_value = thumb.ID
	where thumb_meta.meta_key='_thumbnail_id'
	and thumb_meta.post_id = p.id
) as featured_image,
(
	SELECT GROUP_CONCAT(im.guid SEPARATOR '|') as images
	from `wp_posts` im
	where im.post_type='attachment'
	and p.ID = im.post_parent
) as images,
(
	SELECT GROUP_CONCAT( slug SEPARATOR '|') from `wp_terms` t
	inner join `wp_term_taxonomy` tt  
	on tt.term_id = t.term_id 
	inner join `wp_term_relationships` tr   
	on tr.term_taxonomy_id = tt.term_taxonomy_id 
	where tr.object_id = p.id
	and tt.taxonomy = 'category'
) as categories
from `wp_posts` p
inner join `wp_postmeta` pm1 
on p.ID = pm1.post_id 
where p.post_type = 'post'
group by p.ID;

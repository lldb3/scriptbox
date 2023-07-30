-- Update common tables, TODO: either find an sql way to use the prefix or sed it in a loop with script
use wordpress;

-- Collate is because of charset: https://stackoverflow.com/questions/32511288/illegal-mix-of-collations-utf8mb4-unicode-ci-explicit-and-utf8-general-ci-coe
SET @old_domain='old.example' collate utf8mb4_unicode_ci;
SET @new_domain='new.example' collate utf8mb4_unicode_ci;

SET @old_url='https://wp-blog.old.example' collate utf8mb4_unicode_ci;
SET @new_url='https://wp-blog.new.example' collate utf8mb4_unicode_ci;

-- siteurl, misc options (jetpack)
UPDATE wp_blog_options SET option_value = replace(option_value, @old_url, @new_url) WHERE option_name = 'home' OR option_name = 'siteurl';
-- fix all internal links
UPDATE wp_blog_posts SET post_content = replace(post_content, @old_url, @new_url);
-- fix all internal menue links
UPDATE wp_blog_postmeta SET meta_value = replace(meta_value, @old_url, @new_url);
-- user links
UPDATE wp_blog_usermeta SET meta_value = replace(meta_value, @old_domain, @new_domain);

-- only if needed, rss feeds will be renewed
UPDATE wp_blog_posts SET guid = replace(guid, @old_url, @new_url);


-- ============================================================
--  BICpES Learning Hub — Migration v2
--  Run this ONCE against your bicpes_hub database.
--  It is safe to run multiple times (uses IF NOT EXISTS checks).
-- ============================================================

USE `bicpes_hub`;

-- Add video_url to projects (stores either a URL or an uploaded filename)
ALTER TABLE `projects`
    ADD COLUMN IF NOT EXISTS `video_url` VARCHAR(512) NULL
        COMMENT 'YouTube/external URL  OR  uploaded filename inside Videos/ folder'
        AFTER `video_duration`;

-- Add video_type to projects so the front-end knows how to render it
ALTER TABLE `projects`
    ADD COLUMN IF NOT EXISTS `video_type` ENUM('url','file') NULL DEFAULT NULL
        COMMENT '"url" = external link, "file" = uploaded file in Videos/'
        AFTER `video_url`;
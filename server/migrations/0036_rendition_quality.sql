-- Rendition quality per library (M2-49, the owner's answer to M1-44's question 4): the universal JPEG of a still
-- the client cannot decode is `high` by default (the original's size, q 92-95, with its gain map) and `standard`
-- (2160 px, q 85) for libraries on small disks. The reconciler renders the other preview again when it changes.
ALTER TABLE libraries ADD COLUMN rendition_quality text NOT NULL DEFAULT 'high'
    CHECK (rendition_quality IN ('standard', 'high'));

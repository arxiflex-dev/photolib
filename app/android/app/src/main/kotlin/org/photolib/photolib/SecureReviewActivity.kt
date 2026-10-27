package org.photolib.photolib

/**
 * The camera's review over the lock screen (`REVIEW_SECURE`, ADR-0039): the same activity, declared to show when the
 * phone is locked (AndroidManifest.xml), in a task of its own. It shows only the items the camera sent, to look at:
 * app/lib/features/gallery/secure_review.dart never builds the library, and closing it finishes the task.
 */
class SecureReviewActivity : MainActivity() {
    override val secure = true
}

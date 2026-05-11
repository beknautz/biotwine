/* ============================================================
   BioTwine Admin — admin.js
   Shared admin utilities. Included via admin_close.cfm.
   ============================================================ */

/**
 * btUploadImage — read a file input as Base64 and POST to upload_image.cfm.
 * Bypasses cffile action="upload" temp-file sandbox restrictions by sending
 * the raw Base64 data URL instead of a multipart file upload.
 *
 * @param {HTMLInputElement} input      The file input that triggered change
 * @param {string}           fieldId    ID of the text field to populate with filename/path
 * @param {string}           previewId  ID of the preview container div
 * @param {string}           folder     Upload subfolder (products, img, hero, testimonials)
 */
function btUploadImage(input, fieldId, previewId, folder) {
  if (!input.files || !input.files[0]) return;
  var file = input.files[0];

  // Show uploading state
  var label = input.closest('label') || input.parentElement;
  var origText = (label && label.childNodes[0]) ? label.childNodes[0].textContent.trim() : '';
  if (label && label.childNodes[0]) label.childNodes[0].textContent = 'Uploading… ';

  var reader = new FileReader();
  reader.onload = function(e) {
    var fd = new FormData();
    fd.append('imageData', e.target.result);   // full data URL: data:image/jpeg;base64,...
    fd.append('filename', file.name);
    fd.append('folder', folder || 'img');

    fetch('/admin/upload_image.cfm', { method: 'POST', body: fd })
      .then(function(r) { return r.json(); })
      .then(function(data) {
        if (data.ok) {
          var field = document.getElementById(fieldId);
          if (field) field.value = data.url;
          var prev = document.getElementById(previewId);
          if (prev) {
            prev.innerHTML = '<img src="' + data.url + '" style="max-height:72px; border-radius:4px; border:1px solid var(--border-color); margin-top:0.25rem;" onerror="this.style.display=\'none\'">';
          }
        } else {
          alert('Upload failed: ' + (data.error || 'unknown error'));
        }
      })
      .catch(function() { alert('Upload failed. Check file type and try again.'); })
      .finally(function() {
        if (label && label.childNodes[0] && origText) label.childNodes[0].textContent = origText + ' ';
      });
  };
  reader.readAsDataURL(file);
}

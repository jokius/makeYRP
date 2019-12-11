export default {
  Accept: 'application/json',
  'X-CSRF-Token': document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute('content'),
  'X-Requested-With': 'XMLHttpRequest',
}

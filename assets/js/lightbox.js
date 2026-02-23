(function() {
  var lb = document.getElementById('lightbox');
  if (!lb) return;
  var img = lb.querySelector('.lightbox__img');
  var links = Array.from(document.querySelectorAll('[data-lightbox]'));
  var urls = links.map(function(a) { return a.href; });
  var current = 0;

  function show(i) {
    current = (i + urls.length) % urls.length;
    img.src = urls[current];
    lb.classList.add('lightbox--active');
    document.body.style.overflow = 'hidden';
  }

  function hide() {
    lb.classList.remove('lightbox--active');
    document.body.style.overflow = '';
  }

  links.forEach(function(a, i) {
    a.addEventListener('click', function(e) { e.preventDefault(); show(i); });
  });

  lb.querySelector('.lightbox__close').addEventListener('click', hide);
  lb.querySelector('.lightbox__prev').addEventListener('click', function() { show(current - 1); });
  lb.querySelector('.lightbox__next').addEventListener('click', function() { show(current + 1); });

  lb.addEventListener('click', function(e) {
    if (e.target === lb) hide();
  });

  document.addEventListener('keydown', function(e) {
    if (!lb.classList.contains('lightbox--active')) return;
    if (e.key === 'Escape') hide();
    if (e.key === 'ArrowLeft') show(current - 1);
    if (e.key === 'ArrowRight') show(current + 1);
  });

  var touchStartX = 0;
  lb.addEventListener('touchstart', function(e) { touchStartX = e.touches[0].clientX; });
  lb.addEventListener('touchend', function(e) {
    var dx = e.changedTouches[0].clientX - touchStartX;
    if (Math.abs(dx) > 50) { dx > 0 ? show(current - 1) : show(current + 1); }
  });
})();

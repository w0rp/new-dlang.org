from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.conf.urls.static import static
from django.views.generic import TemplateView
from django.conf import settings

def templ(regex, template):
    return (regex, TemplateView.as_view(template_name= template + ".htm"))

admin.autodiscover()

urlpatterns = patterns("",
    ("^admin/", include(admin.site.urls)),
    templ("^$", "index"),
)

if settings.DEBUG:
    # Serve media files via Django in DEBUG mode.
    urlpatterns += static(settings.MEDIA_URL,
        document_root=settings.MEDIA_ROOT)

    # Serve static files via Django in DEBUG mode.
    urlpatterns += static(settings.STATIC_URL,
        document_root=settings.STATIC_ROOT)


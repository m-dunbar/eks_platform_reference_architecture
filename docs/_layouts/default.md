<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <title>{{ page.title | default: site.title }}</title>

  <link rel="stylesheet" href="{{ '/docs/assets/styles.css' | relative_url }}">
</head>

<body>

  <div class="layout">

    <!-- Navigation -->
    {% include nav.html %}

    <!-- Main content -->
    <main class="content">
      {{ content }}
    </main>

  </div>

  {% include footer.html %}

</body>
</html>

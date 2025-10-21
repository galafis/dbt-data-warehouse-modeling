{% macro surrogate_key(field_list) %}
    md5({% for field in field_list %}
        coalesce(cast({{ field }} as varchar), '')
        {% if not loop.last %} || '|' || {% endif %}
    {% endfor %})
{% endmacro %}

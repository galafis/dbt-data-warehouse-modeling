{% test accepted_range(model, column_name, min_value=none, max_value=none) %}

with validation as (
    select
        {{ column_name }} as field_value
    from {{ model }}
),

validation_errors as (
    select
        field_value
    from validation
    where
        {% if min_value is not none and max_value is not none %}
            field_value < {{ min_value }} or field_value > {{ max_value }}
        {% elif min_value is not none %}
            field_value < {{ min_value }}
        {% elif max_value is not none %}
            field_value > {{ max_value }}
        {% else %}
            false
        {% endif %}
)

select * from validation_errors

{% endtest %}

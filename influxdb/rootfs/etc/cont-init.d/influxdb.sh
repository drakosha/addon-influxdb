#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: InfluxDB
# Configures InfluxDB
# ==============================================================================

# Configures authentication
if bashio::config.true 'auth'; then
    sed -i 's/auth-enabled=.*/auth-enabled=true/' /etc/influxdb/influxdb.conf
else
    bashio::log.warning "InfluxDB authentication protection is disabled!"
    bashio::log.warning "This is NOT recommended!!!"
fi

# Configures usage reporting to InfluxDB
if bashio::config.false 'reporting'; then
    sed -i 's/reporting-disabled=.*/reporting-disabled=true/' /etc/influxdb/influxdb.conf
    bashio::log.info "Reporting of usage stats to InfluxData is disabled."
fi

if bashio::config.true 'graphite'; then
    echo >> /etc/influxdb/influxdb.conf
    echo "[[graphite]]" >> /etc/influxdb/influxdb.conf
    echo "  enabled = true" >> /etc/influxdb/influxdb.conf
    echo "  bind-address = \":2003\"" >> /etc/influxdb/influxdb.conf
    echo "  protocol = \"tcp\"" >> /etc/influxdb/influxdb.conf

    if bashio::config.has_value 'graphite_templates'; then
        echo "  templates = [" >> /etc/influxdb/influxdb.conf
        for template in $(bashio::config 'graphite_templates'); do
            echo "    \"$template\"," >> /etc/influxdb/influxdb.conf
        done
        echo "  ]" >> /etc/influxdb/influxdb.conf
    fi
fi
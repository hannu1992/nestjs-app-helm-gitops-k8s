{{- define "nestjs-app.name" -}}
nestjs-app
{{- end }}

{{- define "nestjs-app.fullname" -}}
{{ include "nestjs-app.name" . }}
{{- end }}
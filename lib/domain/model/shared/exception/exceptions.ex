defmodule SigninappEx.Domain.Model.Shared.Exception.Exceptions do
  @moduledoc """
  Defines exceptions used across the application.
  """

  defstruct [
    :code,
    :detail,
    :category,
    :log_code,
    :log_message,
    :status,
    :additional_info
  ]

  @status %{
    BAD_REQUEST: 400,
    UNAUTHORIZED: 401,
    NOT_FOUND: 404,
    CONFLICT: 409,
    INTERNAL_ERROR: 500
  }

  @code %{
    ER400_00: "INVALID_EMAIL_FORMAT",
    ER400_01: "WEAK_PASSWORD",
    ER400_02: "MALFORMED_REQUEST",
    ER401_00: "INVALID_CREDENTIALS",
    ER404_00: "USER_NOT_FOUND",
    ER409_00: "EMAIL_ALREADY_EXISTS",
    ER500_00: "UNEXPECTED_ERROR"
  }

  @detail %{
    ER400_00: "Email inválido.",
    ER400_01: "El password no cumple con los requisitos de seguridad.",
    ER400_02: "El request recibido está mal formado o faltan campos requeridos.",
    ER401_00: "Las credenciales proporcionadas son incorrectas.",
    ER404_00: "No se encontró un usuario con el identificador proporcionado.",
    ER409_00: "Email ya registrado.",
    ER500_00: "Ocurrió un error inesperado. Por favor, inténtelo de nuevo más tarde."
  }

  @category %{
    BEX_ECS: "BEX_ECS_BUG",
    BEX_ECS_CRIT: "BEX_ECS_CRIT",
    BEX: "BEX_FATAL"
  }

  @log_code %{
    ER400_00_01: "ER400-00-01",
    ER400_01_01: "ER400-01-01",
    ER400_02_01: "ER400-02-01",
    ER400_02_02: "ER400-00-02",
    ER400_02_03: "ER400-00-03",
    ER400_02_04: "ER400-00-04",
    ER400_02_05: "ER400-00-05",
    ER400_02_06: "ER400-00-06",
    ER400_02_07: "ER400-00-07",
    ER400_02_08: "ER400-00-08",
    ER401_00_01: "ER401-00-01",
    ER404_00_01: "ER404-00-01",
    ER409_00_01: "ER409-00-01",
    ER500_00_01: "ER500-00-01"
  }

  @log_message %{
    ER400_00_01: "El formato del email es inválido.",
    ER400_01_01: "El password no cumple con los requisitos de seguridad.",
    ER400_02_01: "El request recibido está mal formado o faltan campos requeridos.",
    ER400_02_02: "El email está vacío o no es de tipo string.",
    ER400_02_03: "El password está vacío o no es de tipo string.",
    ER400_02_04: "El nombre no es de tipo string.",
    ER400_02_05: "Hader 'message-id' no tiene formato válido UUID 4.",
    ER400_02_06: "Hader 'message-id' está vacío o no es de tipo string.",
    ER400_02_07: "Hader 'x-request-id' no tiene formato válido UUID 4.",
    ER400_02_08: "Hader 'x-request-id' está vacío o no es de tipo string.",
    ER401_00_01: "Fallo en la autenticación por credenciales inválidas.",
    ER404_00_01: "Usuario no encontrado en la base de datos.",
    ER409_00_01: "Conflicto al crear usuario: email ya existe.",
    ER500_00_01: "Error inesperado en la aplicación."
  }

  def build_exception(:email_invalid_format) do
    %__MODULE__{
      code: Map.get(@code, :ER400_00),
      detail: Map.get(@detail, :ER400_00),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_00_01),
      log_message: Map.get(@log_message, :ER400_00_01),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:email_empty) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_02),
      log_message: Map.get(@log_message, :ER400_02_02),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:email_invalid_type) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_02),
      log_message: Map.get(@log_message, :ER400_02_02),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:password_empty) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_03),
      log_message: Map.get(@log_message, :ER400_02_03),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:password_invalid_type) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_03),
      log_message: Map.get(@log_message, :ER400_02_03),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:name_invalid_type) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_04),
      log_message: Map.get(@log_message, :ER400_02_04),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:message_id_invalid_format) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_05),
      log_message: Map.get(@log_message, :ER400_02_05),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:message_id_empty) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_06),
      log_message: Map.get(@log_message, :ER400_02_06),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:message_id_invalid_type) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_06),
      log_message: Map.get(@log_message, :ER400_02_06),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:x_request_id_invalid_format) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_07),
      log_message: Map.get(@log_message, :ER400_02_07),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:x_request_id_empty) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_08),
      log_message: Map.get(@log_message, :ER400_02_08),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:x_request_id_invalid_type) do
    %__MODULE__{
      code: Map.get(@code, :ER400_02),
      detail: Map.get(@detail, :ER400_02),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_02_08),
      log_message: Map.get(@log_message, :ER400_02_08),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:user_not_found) do
    %__MODULE__{
      code: Map.get(@code, :ER404_00),
      detail: Map.get(@detail, :ER404_00),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER404_00_01),
      log_message: Map.get(@log_message, :ER404_00_01),
      status: Map.get(@status, :NOT_FOUND)
    }
  end

  def build_exception(:invalid_credentials) do
    %__MODULE__{
      code: Map.get(@code, :ER401_00),
      detail: Map.get(@detail, :ER401_00),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER401_00_01),
      log_message: Map.get(@log_message, :ER401_00_01),
      status: Map.get(@status, :UNAUTHORIZED)
    }
  end

  def build_exception(:password_weak) do
    %__MODULE__{
      code: Map.get(@code, :ER400_01),
      detail: Map.get(@detail, :ER400_01),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER400_01_01),
      log_message: Map.get(@log_message, :ER400_01_01),
      status: Map.get(@status, :BAD_REQUEST)
    }
  end

  def build_exception(:user_already_exists) do
    %__MODULE__{
      code: Map.get(@code, :ER409_00),
      detail: Map.get(@detail, :ER409_00),
      category: Map.get(@category, :BEX_ECS),
      log_code: Map.get(@log_code, :ER409_00_01),
      log_message: Map.get(@log_message, :ER409_00_01),
      status: Map.get(@status, :CONFLICT)
    }
  end

  def build_exception(_) do
    %__MODULE__{
      code: Map.get(@code, :ER500_00),
      detail: Map.get(@detail, :ER500_00),
      category: Map.get(@category, :BEX),
      log_code: Map.get(@log_code, :ER500_00_01),
      log_message: Map.get(@log_message, :ER500_00_01),
      status: Map.get(@status, :INTERNAL_SERVER_ERROR)
    }
  end
end
